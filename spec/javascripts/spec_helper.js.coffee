#= require handlebars.runtime
#= require_tree ./templates
#= require jquery
#= require chai-jquery

window.render = (name, attributes) ->
  html = HandlebarsTemplates[name](attributes)
  $("body").html(html)
