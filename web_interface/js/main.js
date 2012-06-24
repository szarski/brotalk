Controller = Class({
  initialize: function(viewport, log_container, display, greet_button) {
    this.viewport = viewport;
    this.sys = arbor.ParticleSystem(10000, 10,1);
    this.sys.parameters({gravity:true});
    this.sys.renderer = Renderer(viewport) ;
    this.log_container = log_container;
    setInterval(function() {
      this.load_logs();
      this.load_clients();
      this.load_connections();
    }.bind(this), 1000);

    var that = this;
    $(this.viewport).mousedown(function(e){
      var pos = $(this).offset();
      var p = {x:e.pageX-pos.left, y:e.pageY-pos.top}
      selected = nearest = dragged = that.sys.nearest(p);
      that.node_clicked(selected.node);
      return false;
    });

    this.display = $(display);
    $(greet_button).click(this.greet.bind(this));
  },

  selected_node_1: null,
  selected_node_2: null,

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
  },

  load_clients: function() {
    $.get('/clients.json', this.receive_load_clients.bind(this));
  },

  receive_load_clients: function(data) {
    _.each(JSON.parse(data), function(client){
      if (client.supernode)
        this.sys.addNode(client['address'],{'color':'#CFF','shape':'dot','label':client['address']});
      else
        this.sys.addNode(client['address'],{'color':'#CCC','shape':'dot','label':client['address']});
    }.bind(this));
  },

  load_connections: function() {
    $.get('/connections.json', this.load_connections_receive.bind(this));
  },

  load_connections_receive: function(data) {
    _.each(JSON.parse(data), function(description){
      var x=description[0];
      var ys = description[1]
      var node = this.sys.getNode(x);
      if (node) {
        _.each(this.sys.getEdgesFrom(node), function(edge){
          if (!_.include(ys, edge.source.name))
            this.sys.pruneEdge(edge);
        }.bind(this));
      }
      _.each(ys, function(y){
        this.sys.addEdge(y, x, {type: 'ident-arrow',color: 'black', directed: 1});
      }.bind(this));
    }.bind(this));
  },

  greet: function() {
    if (this.selected_node_1 && this.selected_node_2)
      $.get('/clients/'+this.selected_node_1+'/greet/'+this.selected_node_2);
  },

  load_logs: function() {
    $.get('/logs.json', this.load_logs_receive.bind(this));
  },

  load_logs_receive: function(data) {
    var c = $(this.log_container);
    var r = '';
    _.each(JSON.parse(data).reverse(), function(x) {
      r += '<li>'+x+'</li>';
    });
    c.html(r);
  }
});

$(document).ready(function() {
  controller = new Controller("#viewport", "#log_container", "#display", "#greet_button");
  controller.load_clients();
  controller.load_connections();
});
