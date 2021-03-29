class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:destroy]

   def create
     Attachment.create(attachment_params)
     redirect_to :back
   end

   def destroy
     @attachment.destroy
   end

   private

   def set_attachment
     @attachment = Attachment.find(params[:attachments_id])
   end

   def attachment_params
     params.require(:attachment).permit(:image)
   end
 end
