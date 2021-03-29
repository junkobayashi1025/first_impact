class AttachmentsController < ApplicationController
  before_action :set_attachment

   def create
     add_more_images(contents_params[:contents])
     flash[:error] = "Failed uploading images" unless @attachment.save
     redirect_to :back
   end

   def destroy
     remove_content_at_index(params[:id].to_i)
     flash[:error] = "Failed deleting image" unless @attachment.save
     redirect_to :back
   end

   private

   def set_attachment
     @attachment = Attachment.find(params[:attachments_id])
   end

   def add_more_contents(new_contents)
     contents = @attachment.contents
     contents += new_contents
     @attachment.contents = contents
   end

   def remove_content_at_index(index)
      remain_contents = @attachment.contents
      if index == 0 && @attachment.contents.size == 1
        @attachment.remove_contents!
      else
        deleted_content = remain_contents.delete_at(index)
        deleted_content.try(:remove!)
        @attachment.contents = remain_contents
      end
   end

   def contents_params
     params.require(:attachment).permit({contents: []}) # allow nested params as array
   end
 end





#   before_action :report_params, only: [:destroy]
#
#   def destroy
#     # binding.pry
#     @attachment = Attachment.find_by(report_id: params[:id])
#     if @attachment.destroy
#       render 'show'
#     end
#   end
#
#   # def destroy
#   #   @bookmark = Bookmark.find(params[:id])
#   #   @report = @bookmark.post
#
#   # end
#
#   private
#   def report_params
#     @report = Report.find(params[:id])
#   end
# end
