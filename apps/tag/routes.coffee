Q = require 'q'
qs = require 'qs'
Backbone = require 'backbone'
Tag = require '../../models/tag'
FilterArtworks = require '../../collections/filter_artworks'
aggregationParams = require './aggregations.coffee'

@index = (req, res, next) ->
  tag = new Tag(id: req.params.id)
  filterArtworks = new FilterArtworks
  params = new Backbone.Model tag: tag.id
  filterData = { size: 0, tag: req.params.id, aggregations: aggregationParams }
  formattedFilterData = decodeURIComponent qs.stringify(filterData, { arrayFormat: 'brackets' })
  Q.all([
    tag.fetch(cache: true)
    filterArtworks.fetch(data: formattedFilterData)
  ]).done ->
    res.locals.sd.FILTER_ROOT = tag.href() + '/artworks'
    res.locals.sd.TAG = tag.toJSON()
    res.locals.sd.FILTER_PARAMS = new Backbone.Model tag: tag.id

    res.render 'index',
      tag: tag
      filterRoot: res.locals.sd.FILTER_ROOT
      counts: filterArtworks.counts
      params: params
      activeText: ''
