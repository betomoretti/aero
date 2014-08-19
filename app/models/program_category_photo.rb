class ProgramCategoryPhoto < ActiveRecord::Base
  	belongs_to :category_program

    has_attached_file :download,
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
    validates_as_attachment

    
end