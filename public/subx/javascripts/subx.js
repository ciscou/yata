(function() {
  var SubX;

  SubX = (function() {

    function SubX() {}

    SubX.prototype.report = function(times) {
      var report;
      report = {};
      $(times).each(function(i, e) {
        var sub, _ref;
        sub = Math.floor(e) + 1;
        if ((_ref = report[sub]) == null) {
          report[sub] = 0;
        }
        return report[sub] += 1;
      });
      return report;
    };

    return SubX;

  })();

  $(function() {
    var subx;
    subx = new SubX;
    return $("form").submit(function(e) {
      var k, report, source, subxs, template, times, v;
      e.preventDefault();
      times = $("#times").val().split(/\s*,\s*/);
      times = $(times).map(function(i, e) {
        return parseFloat(e);
      });
      report = subx.report(times);
      subxs = [];
      for (k in report) {
        v = report[k];
        subxs.push({
          sub: k,
          count: v
        });
      }
      source = $("#subxs-template").html();
      template = Handlebars.compile(source);
      return $("#subxs").html(template({
        subxs: subxs
      }));
    });
  });

}).call(this);
