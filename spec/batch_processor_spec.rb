require_relative '../batch_processor'

describe BatchProcessor do
  context "single batch" do
    let(:batch) { [1, 1, 2, 3] }
    let(:processed_items) { [1, 2, 3] }

    describe "#process_items" do
      it "calls block" do
        expect { |b| subject.process_items(batch, &b) }.to yield_successive_args(*processed_items)
      end
    end

    describe "#processed_items" do
      it "processes each item" do
        subject.process_items(batch)
        expect(subject.processed_items).to eq(processed_items)
      end
    end

    describe "#identify" do
      context "hash array is passed" do
        let(:batch) {
          [ {'id' => 1}, {'id' => 1, 'name' => 'example'}, {'id' => 2} ]
        }
        let(:processed_items) {
          [ {'id' => 1}, {'id' => 2} ]
        }
        it "processes items" do
          subject.identify('id')
          subject.process_items(batch)
          expect(subject.processed_items).to eq(processed_items)
        end
      end

      context "object array is passed" do
        let(:obj_class) { Class.new(Struct.new(:id, :name)) }

        let(:batch) {
          [
            obj_class.new( 1, "First"),
            obj_class.new( 2, "Second"),
            obj_class.new( 1, "First Repeated")
          ]
        }

        let(:processed_items) {
          [
            obj_class.new( 1, "First"),
            obj_class.new( 2, "Second")
          ]
        }

        it "processes items" do
            subject.identify('id')
            subject.process_items(batch)
            expect(subject.processed_items).to eq(processed_items)
          end
        end
    end

  end

  context "two batches" do
    let(:batch) { [1, 2, 3] }
    let(:second_batch) { [3, 1, 5] }
    let(:processed_items) { [1, 2, 3, 5] }

    describe "#process_items" do
      it "calls block" do
        expect do |b|
          subject.process_items(batch, &b)
          subject.process_items(second_batch, &b)

        end.to yield_successive_args(*processed_items)
      end
    end

    describe "#processed_items" do
      it "processes each item once" do
        subject.process_items(batch)
        subject.process_items(second_batch)
        expect(subject.processed_items).to eq(processed_items)
      end
    end
  end

end


# Minimum 36 minutes
