fs = require 'fs-plus'
path = require 'path'
SelectListView = require 'atom-select-list'

module.exports =
  init: ->
    @selectListView = new SelectListView({
      emptyMessage: 'No recordings found.',
      items: [],
      filterKeyForItem: (item) -> item,
      elementForItem: (item) ->
        element = document.createElement 'li'
        html = "<b>#{path.basename(item)}</b>"
        html += "<img src=\"#{item}\">"
        element.innerHTML = html
        element
      didConfirmSelection: (item) =>
        @cancel()
        @open(item)
      didCancelSelection: () =>
        @cancel()
    })
    @selectListView.element.classList.add('recordings-list')

  dispose: ->
    @cancel()
    @selectListView.destroy()

  cancel: ->
    if @panel?
      @panel.destroy()
    @panel = null
    if @previouslyFocusedElement
      @previouslyFocusedElement.focus()
      @previouslyFocusedElement = null

  attach: ->
    @previouslyFocusedElement = document.activeElement
    if not @panel?
      @panel = atom.workspace.addModalPanel({item: @selectListView})
    @selectListView.focus()
    @selectListView.reset()

  toggle: ->
    if @panel?
      @cancel()
    else
      dir = atom.config.get('screen-recorder.targetDirectory')
      fs.list dir, ['gif'], (error, files) =>
        @selectListView.update({items: files})
        @attach()

  open: (file) ->
    atom.workspace.open file
