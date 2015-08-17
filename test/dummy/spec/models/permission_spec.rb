require "spec_helper"

describe Goldencobra::Permission, type: :model do
  describe "restricted?" do
    context "with restricted items" do
      it "returns true" do
        create(:permission,
               subject_class: "Goldencobra::Article",
               subject_id: 1)

        article = double(Goldencobra::Article, id: 1, class: "Goldencobra::Article")

        expect(Goldencobra::Permission.restricted?(article)).to eq(true)
      end
    end

    context "without restricted items" do
      it "returns false" do
        article = double(Goldencobra::Article, id: 1, class: "Goldencobra::Article")

        expect(Goldencobra::Permission.restricted?(article)).to eq(false)
      end
    end
  end

  describe "#set_min_sorter_id" do
    context "without existing permissions" do
      it "sets the sorter_id to 0" do
        expect(Goldencobra::Permission.all.count).to eq 0

        perm = create :permission

        expect(perm.sorter_id).to eq 0
      end
    end

    context "with existing permissions" do
      it "increments the sorter_id from the last object_id" do
        expect(Goldencobra::Permission.all.count).to eq 0

        perm1 = create :permission

        perm2 = create :permission

        expect(perm2.sorter_id).to eq(perm1.id + 1)
      end
    end
  end
end
