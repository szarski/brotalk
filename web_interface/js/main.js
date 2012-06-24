Controller = Class({
  initialize: function(viewport) {
    this.sys = arbor.ParticleSystem(1000, 400,1);
    this.sys.parameters({gravity:true});
    this.sys.renderer = Renderer(viewport) ;
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
  }
});

$(document).ready(function() {
  controller = new Controller("#viewport");
  controller.load_clients();
  controller.load_connections();
});
