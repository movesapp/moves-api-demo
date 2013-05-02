/* adapted from http://bl.ocks.org/mbostock/1346410 */

var visualize = function(steps) {
    var dataset = {
      "default": [1, 0, 0, 0, 0, 0, 0]
    };

    var width = $(window).width() * 0.9,
        height = $(window).height() * 0.8,
        radius = Math.min(width, height) / 2;

    var color = d3.scale.category20();

    var pie = d3.layout.pie()
        .sort(null);

    var arc = d3.svg.arc()
        .innerRadius(radius / 1.5)
        .outerRadius(radius / 3 );

    var svg = d3.select("#chart").append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    var path = svg.selectAll("path")
        .data(pie(dataset["default"]))
      .enter().append("path")
        .attr("fill", function(d, i) { return color(i); })
        .attr("d", arc)
        .each(function(d) { this._current = d; }); // store the initial values

    var timeout = setTimeout(change, 2000);

    function change() {
      clearTimeout(timeout);
      path = path.data(pie(steps)); // update the data
      path.transition().duration(750).attrTween("d", arcTween); // redraw the arcs
    }

    function arcTween(a) {
      var i = d3.interpolate(this._current, a);
      this._current = i(0);
      return function(t) {
        return arc(i(t));
      };
    }
};
