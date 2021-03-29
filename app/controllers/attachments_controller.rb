class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:destroy]

   def create
     Attachment.create(attachment_params)
     redirect_to :back
   end

   def destroy
     @attachment.destroy
     redirect_to report_path(@attachment.report)
   end

   private

   def set_attachment
     @attachment = Attachment.find(params[:id])
   end

   def attachment_params
     params.require(:attachment).permit(:image)
   end
 end
