require 'pry'
require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe '#update_quality' do
    let!(:items) { [Item.new("foo", 0, 0)] }
    let(:guilded_rose_store) { GildedRose.new(items) }

    it 'does not change the name' do
      guilded_rose_store.update_quality

      expect(items[0].name).to eq("foo")
    end

    it 'the quality can not be less than 0' do
      guilded_rose_store.update_quality

      expect(items[0].quality).to eq(0)
    end

    it 'regular items decrease the quality and SellIn values every night' do
      items = [Item.new('Regular Item', 1,10)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(9)
      expect(updated_item.first.sell_in).to eq(0)
    end

    it 'regular items decrease the quality twice fast when sell by date has passed' do
      items = [Item.new('Regular Item', 0,10)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(8)
    end

    it 'Aged Brie items increase its quality with the time' do
      items = [Item.new(name="Aged Brie", sell_in = 2, quality = 0)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(1)
    end

    it 'the quality of an item is never more than 50' do
      items = [Item.new(name="Aged Brie", sell_in = 2, quality = 50)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(50)
    end

    it 'Sulfuras, being a legendary item, never has to be sold or decreases in Quality' do
      items = [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in = 2, quality = 50)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(50)
      expect(updated_item.first.sell_in).to eq(2)
    end

    it 'Backstage passes increase its quality by 2 when there are 10 days or less' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in = 10, quality = 20)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(22)
    end

    it 'Backstage passes increase its quality by 3 when there are 5 days or less' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in = 5, quality = 20)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(23)
    end

    it 'Backstage passes decrease its quality to 0 after the concert' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in = 0, quality = 20)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(0)
    end

    it 'the quality of the items can not be more than 50' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in = 1, quality = 49)]
      updated_item = GildedRose.new(items).update_quality

      expect(updated_item.first.quality).to eq(50)
    end
  end
end
