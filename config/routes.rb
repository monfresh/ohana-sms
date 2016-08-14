# frozen_string_literal: true
Rails.application.routes.draw do
  get 'locations/reply' => 'locations#reply'
end
