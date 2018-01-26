require 'spec_helper'

describe CalloutsController do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "POST #dismiss" do
    subject { post :dismiss, feature_name: 'feature_name', format: :json }

    context 'when callout entry does not exist' do
      it 'should create a callout entry with dismissed state' do
        expect { subject }.to change { Callout.count }.by(1)
      end

      it 'should return success' do
        subject

        expect(response).to have_gitlab_http_status(:ok)
      end
    end

    context 'when callout entry already exists' do
      let!(:callout) { create(:callout, feature_name: 'feature_name', user: user) }

      it 'should update it with a dismissed state' do
        expect { subject }.to change { callout.reload.dismissed_state }.from(false).to(true)
      end

      it 'should return success' do
        subject

        expect(response).to have_gitlab_http_status(:ok)
      end
    end
  end
end
