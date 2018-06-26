class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if is_regular_item?(item)
        update_regular_item_attributes(item)
      elsif is_aged_brie_item?(item)
        update_aged_brie_item_attributes(item)
      elsif is_backstage_passes_item?(item)
        update_backstage_item_attributes(item)
      elsif is_conjured_item?(item)
        update_conjured_item_attributes(item)
      elsif is_legendary_item?(item)
        item
      end
    end
  end

  def decrease_item_quality(item, amount)
    if item.quality > 0
      item.quality -= amount
    end
  end

  def increase_quality(item, amount)
    if (item.quality + amount) <= 50
      item.quality += amount
    else
      item.quality = 50
    end
  end

  def update_aged_brie_item_attributes(item)
    increase_quality(item, 1)
    item.sell_in -= 1
  end

  def update_regular_item_attributes(item)
    item.sell_in < 1 ? decrease_item_quality(item, 2) : decrease_item_quality(item, 1)
    item.sell_in -= 1
  end

  def update_backstage_item_attributes(item)
    if item.sell_in < 1
      item.quality = 0
    elsif item.sell_in < 6
      increase_quality(item, 3)
    elsif item.sell_in < 11
      increase_quality(item,2)
    else
      increase_quality(item, 1)
    end
    item.sell_in -= 1
  end

  def update_conjured_item_attributes(item)
    item.sell_in -= 1
    decrease_item_quality(item, 2)
  end

  def is_regular_item?(item)
    !is_aged_brie_item?(item) && !is_legendary_item?(item) &&
        !is_backstage_passes_item?(item) && !is_backstage_passes_item?(item) && !is_conjured_item?(item)
  end

  def is_aged_brie_item?(item)
    item.name == 'Aged Brie'
  end

  def is_legendary_item?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def is_backstage_passes_item?(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def is_conjured_item?(item)
    item.name == 'Conjured Mana Cake'
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end