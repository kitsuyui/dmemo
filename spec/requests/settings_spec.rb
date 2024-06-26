require "rails_helper"

describe :settings, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:data_source) { FactoryBot.create(:data_source, name: "test_ds") }
  let!(:ignored_table) { FactoryBot.create(:ignored_table, data_source:) }
  before do
    login!(user:)
  end

  describe "#show" do
    it "shows settings" do
      get setting_path
      expect(response).to render_template("settings/show")
      expect(page).to have_xpath("//*[@class='container-data_sources']//*[contains(text(), 'test_ds')]")
      expect(page).to have_xpath("//*[@class='container-ignored_tables']//*[contains(text(), 'test_ds')]")

      expect(page).not_to have_xpath("//a[@href='#{data_source_path(data_source)}']")
      expect(page).not_to have_xpath("//a[@href='#{ignored_table_path(ignored_table)}']")
    end

    context "with admin user" do
      let(:user) { FactoryBot.create(:user, admin: true) }

      it "shows admin buttons" do
        get setting_path
        expect(response).to render_template("settings/show")
        expect(page).to have_xpath("//*[@class='container-data_sources']//*[contains(text(), 'test_ds')]")
        expect(page).to have_xpath("//*[@class='container-ignored_tables']//*[contains(text(), 'test_ds')]")

        expect(page).to have_xpath("//a[@href='#{data_source_path(data_source)}']")
        expect(page).to have_xpath("//a[@href='#{ignored_table_path(ignored_table)}']")
      end
    end
  end
end
