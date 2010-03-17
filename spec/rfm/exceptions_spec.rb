require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Rfm
  describe FileMakerError do
    describe ".get" do
      
      it "should return a default system error if input code is 0" do
        error = FileMakerError.get(0)
        error.message.should eql('SystemError occurred: (FileMaker Error #0)')
        error.code.should eql(0)
      end
      
      it "should return a custom message as second argument" do
        error = FileMakerError.get(104, 'Custom Message Here.')
        error.message.should match(/Custom Message Here/)
      end
    
      it "should return a script missing error" do
        error = FileMakerError.get(104)
        error.message.should eql('ScriptMissingError occurred: (FileMaker Error #104)')
        error.code.should eql(104)
      end  
      
      it "should return a range validation error" do
        error = FileMakerError.get(503)
        error.message.should eql('RangeValidationError occurred: (FileMaker Error #503)')
        error.code.should eql(503)
      end  
      
      it "should return unknown error if code not found" do
        error = FileMakerError.get(-1)
        error.message.should eql('UnknownError occurred: (FileMaker Error #-1)')
        error.code.should eql(-1)
        error.class.should eql(UnknownError)
      end
      
    end
    
    describe ".instantiate_error" do
      it "should create a class based on the constant recieved" do
        error = FileMakerError.instantiate_error(UnknownError, ': message for error')
        error.class.should eql(UnknownError)
      end
    end
    
    describe ".find_error_by_code" do
      it "should return a constant representing the error class" do
        constant = FileMakerError.find_error_by_code(503)
        constant.should eql(RangeValidationError)
      end
    end
    
    describe ".cource_message" do
      before(:each) do
        @message = FileMakerError.cource_message(503, 'This is a custom message')
      end
      
      it "should return a string with the code and message included" do
        @message.should match(/This is a custom message/)
        @message.should match(/503/)
      end
      
      it "should look like" do
        @message.should eql(': This is a custom message (FileMaker Error #503)')
      end
    end
    
  end
end
