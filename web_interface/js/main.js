Controller = Class({
  initialize: function(viewport, log_container) {
    this.sys = arbor.ParticleSystem(1000, 400,1);
    this.sys.parameters({gravity:true});
    this.sys.renderer = Renderer(viewport) ;
    this.log_container = log_container;
    setInterval(this.load_logs.bind(this), 1000);
  },

  load_clients: function() {
    $.get('/clients.json', this.receive_load_clients.bind(this));
  },

  receive_load_clients: function(data) {
    _.each(JSON.parse(data), function(client){
      this.sys.addNode(client['address'],{'color':'#CCC','shape':'dot','label':client['address']});
    }.bind(this));
  },

  load_connections: function() {
    $.get('/connections.json', this.load_connections_receive.bind(this));
  },

  load_connections_receive: function(data) {
    _.each(JSON.parse(data), function(description){
      x=description[0];
      _.each(description[1], function(y){
        this.sys.addEdge(x,y, {type: 'ident-arrow',color: 'black', directed: 1});
      }.bind(this));
    }.bind(this));
  },

  greet: function(sender, receiver) {
    $.get('/clients/'+sender+'/greet/'+receiver);
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
  controller = new Controller("#viewport", "#log_container");
  controller.load_clients();
  controller.load_connections();
});
