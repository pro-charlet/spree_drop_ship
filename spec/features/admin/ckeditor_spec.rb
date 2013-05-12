require 'spec_helper'

feature 'Admin - Ckeditor Assets', js: true do

  context 'as a Supplier' do

    before do
      @user1 = create(:supplier_user)
      @user2 = create(:supplier_user)

      @product = create(:product, supplier: @user1.supplier)
      @product.product_updates.create(body: 'Example body.', title: 'Foo Update')
      @file = File.new(Rails.root.join('spec/support/files/cyrus.png'))

      @picture = Ckeditor::Picture.new
      @picture.data = @file
      @picture.supplier = @user1.supplier
      @picture.save

      @asset = Ckeditor::AttachmentFile.new
      @asset.data = @file
      @asset.supplier = @user1.supplier
      @asset.save
    end

    scenario 'picture can be read by user associated with supplier' do
      login_user @user1
      visit ckeditor.pictures_path
      page.should have_content(File.basename(@file))
    end

    scenario 'picture cannot be read by user associated with different supplier' do
      login_user @user2
      visit ckeditor.pictures_path
      page.should_not have_content(File.basename(@file))
    end

    scenario 'attachment can be read by user associated with supplier' do
      pending
      login_user @user1
      visit ckeditor.attachment_files_path
      page.should have_content(File.basename(@file))
    end

    scenario 'attachment cannot be read by user associated with different supplier' do
      pending
      login_user @user2
      visit ckeditor.attachment_files_path
      page.should_not have_content(File.basename(@file))
    end
  end
end
