var redraw;

window.onload = function() {

$.get('/clients.json', draw);


}

function draw(data) {
    var width = $(document).width();
    var height = $(document).height() - 100;

    var g = new Graph();
    



    /* creating nodes and passing the new renderer function to overwrite the default one */


    _.each(JSON.parse(data), function(client){
      g.addNode(client['address']);
    });

    /* layout the graph using the Spring layout implementation */
    var layouter = new Graph.Layout.Spring(g);
    
    /* draw the graph using the RaphaelJS draw implementation */
    var renderer = new Graph.Renderer.Raphael('canvas', g, width, height);

    redraw = function() {
        layouter.layout();
        renderer.draw();
    };
    
};
