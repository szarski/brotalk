Controller = Class({
  nodes: {},

  initialize: function(viewport, log_container, display, greet_button) {
    this.viewport = viewport;
    this.sys = arbor.ParticleSystem(10000, 10,1);
    this.sys.parameters({gravity:true});
    this.sys.renderer = Renderer(viewport) ;
    this.log_container = log_container;
    this.load_logs();
    this.load_clients();
    this.load_connections();

    var that = this;
    $(this.viewport).mousedown(function(e){
      e.preventDefault();
      var pos = $(this).offset();
      var p = {x:e.pageX-pos.left, y:e.pageY-pos.top}
      selected = nearest = dragged = that.sys.nearest(p);
      if (e.which === 3)
        that.node_rightclicked(selected.node);
      else
        that.node_clicked(selected.node);
      return false;
    });

    this.display = $(display);
    $(greet_button).click(this.greet.bind(this));
  },

  selected_node_1: null,
  selected_node_2: null,

  node_rightclicked: function(node) {
    this.remove(node.name);
  },

  node_clicked: function(node) {
    var old_color = node.data.color;
    node.data.color = 'red';
    setTimeout(function(){node.data.color = old_color}, 200);
    if (this.selected_node_1 && this.selected_node_2) {
      this.selected_node_1 = null;
      this.selected_node_2 = null;
    }
    if (!this.selected_node_1)
      this.selected_node_1 = node.name;
    else
      this.selected_node_2 = node.name;
    this.update_selected_nodes();
  },
  
  update_selected_nodes: function() {
    this.display.text('selected nodes: "'+this.selected_node_1+'", "'+this.selected_node_2+'"')
    if (this.selected_node_1 && this.selected_node_2) {
      this.greet();
    }
  },

  load_clients: function() {
    $.get('/clients.json', this.receive_load_clients.bind(this)).complete(function(){setTimeout(this.load_clients.bind(this), 2000)}.bind(this));
  },

  receive_load_clients: function(data) {
    var clients = JSON.parse(data);
    var existing_addresses = _.map(clients, function(c){return c['address']});
    _.each(_.keys(this.nodes), function(address) {
      if (!_.include(existing_addresses, address)) {
        var node = this.nodes[address];
        _.each(this.sys.getEdgesTo(node), function(edge){
          this.sys.pruneEdge(edge);
        }.bind(this));
        this.sys.pruneNode(node);
        delete this.nodes[address];
      }
    }.bind(this));
    _.each(clients, function(client){
      if (client.supernode)
        this.nodes[client['address']] = this.sys.addNode(client['address'],{'color':'#CFF','shape':'dot','label':client['address']});
      else
        this.nodes[client['address']] = this.sys.addNode(client['address'],{'color':'#CCC','shape':'dot','label':client['address']});
    }.bind(this));
  },

  load_connections: function() {
    $.get('/connections.json', this.load_connections_receive.bind(this)).complete(function(){setTimeout(this.load_connections.bind(this), 2000)}.bind(this));
  },

  load_connections_receive: function(data) {
    _.each(JSON.parse(data), function(description){
      var x=description[0];
      var ys = description[1]
      var node = this.sys.getNode(x);
      if (node) {
        _.each(this.sys.getEdgesTo(node), function(edge){
          if (!_.include(ys, edge.source.name))
            this.sys.pruneEdge(edge);
        }.bind(this));
      }
      _.each(ys, function(y){
        this.sys.addEdge(y, x, {type: 'ident-arrow',color: 'black', directed: 1});
      }.bind(this));
    }.bind(this));
  },

  remove: function(node) {
    $.get('/clients/'+node+'/remove');
  },

  greet: function() {
    if (this.selected_node_1 && this.selected_node_2)
      $.get('/clients/'+this.selected_node_1+'/greet/'+this.selected_node_2);
  },

  load_logs: function() {
    $.get('/logs.json', this.load_logs_receive.bind(this)).complete(function(){setTimeout(this.load_logs.bind(this), 2000)}.bind(this));
  },

  load_logs_receive: function(data) {
    var c = $(this.log_container);
    var r = '';
    _.each(_.first(JSON.parse(data).reverse(),1000), function(x) {
      r += '<li>'+x+'</li>';
    });
    c.html(r);
  }
});

$(document).ready(function() {
  controller = new Controller("#viewport", "#log_container", "#display", "#greet_button");
});
