require 'spec_helper'

describe Smartgen::Engine::Base do
  describe "processing" do
    it "should just return body" do
      body = 'body'
      subject.process(body).should == body
    end
    
    describe "pre processing" do
      before do
        Smartgen::Engine::Base.pre_processors = []
      end
      
      context "without pre processors" do
        it "should just return body" do
          body = 'body'
          subject.process(body).should == body
        end
      end
      
      context "with pre processors" do
        class PreProcessor
          def process(body) # just needs to respond_to?(:process)
            "<pre_processed>#{body}</pre_processed>"
          end
        end
        
        it "should pre process body" do
          Smartgen::Engine::Base.register(PreProcessor.new)
          
          body = 'body'
          subject.process(body).should == "<pre_processed>#{body}</pre_processed>"
        end
        
        it "should do run pre processors in the order they were registered" do
          class AnotherPreProcessor
            def process(body)
              body.gsub(/pre_processed/, 'another')
            end
          end
          
          Smartgen::Engine::Base.register(PreProcessor.new)
          Smartgen::Engine::Base.register(AnotherPreProcessor.new)
          
          body = 'body'
          subject.process(body).should == "<another>#{body}</another>"
        end
        
        context "of a subclass" do
          class OtherPreProcessor
            def process(body)
              "<another>#{body}</another>"
            end
          end
          
          class MyCustomEngine < Smartgen::Engine::Base
          end
          
          it "should pre process body with different processor of ancestor" do
            Smartgen::Engine::Base.register(PreProcessor.new)
            MyCustomEngine.register(OtherPreProcessor.new)
            
            body = 'body'
            MyCustomEngine.new.process(body).should == "<another>#{body}</another>"
          end
        end
      end
    end
  end
end
