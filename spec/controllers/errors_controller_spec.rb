require 'spec_helper'

describe ErrorsController do
  describe '#error_404' do
    it 'renders the 404 error template' do
      get :error_404
      response.should render_template('errors/error_404')
    end
  end

  describe '#error_404' do
    it 'renders the 500 error template' do
      get :error_500
      response.should render_template('errors/error_500')
    end
  end
end
