DEFAULT_CLASS_PROTOTYPE = {
  option_or_default: function(option, default_value) {
    return typeof(option) == "undefined" ? default_value : option;
  }
};

Class = function(instance_methods, class_methods){
  var klass = function(){
    var prototype = $.extend({},DEFAULT_CLASS_PROTOTYPE);
    for (key in klass.prototype) {
      prototype[key] = klass.prototype[key];
    }
    prototype.initialize.apply(prototype, arguments);
    klass.all.push(prototype);
    var id = klass.all.length;
    prototype.id = function(){return id};
    return prototype;
  }

  klass.prototype = instance_methods;
  for (key in class_methods) {
    klass[key] = class_methods[key];
  }

  klass.all = [];
  return klass;
}
