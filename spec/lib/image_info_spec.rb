require 'rails_helper'

RSpec.describe ImageInfo do
  describe 'static' do
    describe 'PNG' do
      let(:image) { described_class.new(Fixture.new('images/static.png').filename) }

      it '#type should be :png' do
        expect(image.type).to be(:png)
      end

      it '#animated? should be false' do
        skip 'Does not work on ImageMagick 6' unless MiniMagick.imagemagick7?
        expect(image).not_to be_animated
      end
    end

    describe 'GIF' do
      let(:image) { described_class.new(Fixture.new('images/static.gif').filename) }

      it '#type should be :gif' do
        expect(image.type).to be(:gif)
      end

      it '#animated? should be false' do
        expect(image).not_to be_animated
      end
    end

    describe 'JPEG' do
      let(:image) { described_class.new(Fixture.new('images/static.jpg').filename) }

      it '#type should be :jpeg' do
        expect(image.type).to be(:jpeg)
      end

      it '#animated? should be false' do
        expect(image).not_to be_animated
      end
    end

    describe 'WebP' do
      let(:image) { described_class.new(Fixture.new('images/static.webp').filename) }

      it '#type should be :webp' do
        expect(image.type).to be(:webp)
      end

      it '#animated? should be false' do
        expect(image).not_to be_animated
      end
    end
  end

  describe 'animated' do
    describe 'PNG' do
      let(:image) { described_class.new(Fixture.new('images/animated.png').filename) }

      it '#type should be :apng' do
        expect(image.type).to be(:apng)
      end

      it '#animated? should be true' do
        expect(image).to be_animated
      end
    end

    describe 'GIF' do
      let(:image) { described_class.new(Fixture.new('images/animated.gif').filename) }

      it '#type should be :gif' do
        expect(image.type).to be(:gif)
      end

      it '#animated? should be true' do
        expect(image).to be_animated
      end
    end

    describe 'WebP' do
      let(:image) { described_class.new(Fixture.new('images/animated.webp').filename) }

      it '#type should be :webp' do
        expect(image.type).to be(:webp)
      end

      it '#animated? should be true' do
        expect(image).to be_animated
      end
    end
  end
end
