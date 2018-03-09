## Have to split out the Active Admin require so we can override here

#= require jquery
#= require active_admin/jquery_ui
#= require jquery_ujs

#= require_self

#= require active_admin/lib/has_many
#= require active_admin/lib/batch_actions
#= require active_admin/lib/checkbox-toggler
#= require active_admin/lib/dropdown-menu
#= require active_admin/lib/flash
#= require active_admin/lib/modal_dialog
#= require active_admin/lib/per_page
#= require active_admin/lib/table-checkbox-toggler

#= require active_admin/ext/jquery-ui
#= require active_admin/ext/jquery.js.coffee

#= require active_admin/initializers/batch_actions
#= require active_admin/initializers/datepicker
#= require active_admin/initializers/filters
#= require active_admin/initializers/tabs

#= require arctic_admin
#= require active_admin.custom
#= require addl_jquery/addl_jquery

window.ActiveAdmin = {}
