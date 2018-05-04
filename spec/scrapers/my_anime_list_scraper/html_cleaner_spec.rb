require 'rails_helper'

RSpec.describe MyAnimeListScraper::HtmlCleaner do
  context 'with a spoiler' do
    subject do
      described_class.new(<<~HTML)
        Lorem ipsum dolor sit amet <div class="spoiler"><input type="button" class="button show_button" onclick="this.nextSibling.style.display='inline-block';this.style.display='none';" data-showname="Show spoiler" data-hidename="Hide spoiler" value="Show spoiler"><span class="spoiler_content" style="display:none"><input type="button" class="button hide_button" onclick="this.parentNode.style.display='none';this.parentNode.parentNode.childNodes[0].style.display='inline-block';" value="Hide spoiler"><br>consectitur anum</span></div>
      HTML
    end

    it 'should replace the MAL spoiler tags with a <spoiler> node' do
      expect(subject.to_s).to include('<spoiler>')
    end

    it 'should strip the leading <br> inside the spoiler tag' do
      expect(subject.to_s).not_to include('<spoiler><br>')
      expect(subject.to_s).to include('<spoiler>consectitur anum</spoiler>')
    end
  end

  context 'with a data list' do
    subject do
      described_class.new(<<~HTML)
        Full Name: Senjougahara Hitagi<br>
        Oddity: Heavy stone crab<br>
        <br>
        This is some text
      HTML
    end

    it 'should hoist the data into a top level <data> tag' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.css('data')).to be_present
    end

    it 'should include all the data items in the <data> list' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.at_css("dt:contains('Full Name') + dd").content).to eq('Senjougahara Hitagi')
      expect(doc.at_css("dt:contains('Oddity') + dd").content).to eq('Heavy stone crab')
    end

    it 'should leave the text below intact' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.at_css('p').content.strip).to eq('This is some text')
    end
  end

  context 'with a source' do
    subject do
      described_class.new(<<~HTML)
        This is some text.<br>
        <br>
        (Source: Wikipedia)
      HTML
    end

    it 'should move the source into a <source> tag' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.at_css('source')).to be_present
      expect(doc.at_css('source').content.strip).to eq('Wikipedia')
    end
  end

  context 'with a list of data containing nested spoilers' do
    subject do
      described_class.new(<<~HTML)
        Race: Human, Shinigami, <div class="spoiler"><input type="button" class="button show_button" onclick="this.nextSibling.style.display='inline-block';this.style.display='none';" data-showname="Show spoiler" data-hidename="Hide spoiler" value="Show spoiler"><span class="spoiler_content" style="display:none"><input type="button" class="button hide_button" onclick="this.parentNode.style.display='none';this.parentNode.parentNode.childNodes[0].style.display='inline-block';" value="Hide spoiler"><br>Visored, Fullbringer, Quincy</span></div><br>
        Birthday: July 15 (Cancer)<br>
        Age: 15 (beginning); 17 (currently)<br>
        Height: 174-&gt;181 cm<br>
        Weight: 61-&gt;66 kg<br>
        Known Relatives: Isshin Kurosaki (father), Masaki Kurosaki (mother, deceased), Yuzu Kurosaki (younger sister), Karin Kurosaki (younger sister),  <div class="spoiler"><input type="button" class="button show_button" onclick="this.nextSibling.style.display='inline-block';this.style.display='none';" data-showname="Show spoiler" data-hidename="Hide spoiler" value="Show spoiler"><span class="spoiler_content" style="display:none"><input type="button" class="button hide_button" onclick="this.parentNode.style.display='none';this.parentNode.parentNode.childNodes[0].style.display='inline-block';" value="Hide spoiler"><br>Orihime Inoue (wife), Kazui Kurosaki (son)</span></div><br>
        Theme Songs: "Number One" by Hazel Fernandes, "News From the Front" by Bad Religion<br>
        <br>
        For the most part, Ichigo appears like a normal teenage boy, the one exception to that is his spiky, orange hair, a trait which he has been ridiculed about for years. He is a fairly tall, and lean-built person with peach skin and brown eyes. Since becoming a Shinigami, he has become noticeably more muscular, as noted by his sister Karin. When in his spiritual form, Ichigo wears standard Shinigami attire with the addition of a strap across his chest.<br>
        <br>
      HTML
    end

    it 'should properly create a <data> tag' do
      expect(subject.to_s).to include('<data>')
    end

    it 'should fill the <data> tag with a dictionary list of the data' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.css('data > dl')).to be_present
      expect(doc.css("data > dl > dt:contains('Race')")).to be_present
    end

    it 'should include a <spoiler> tag within the <dd> node for Race' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.css("dt:contains('Race') + dd spoiler")).to be_present
    end

    it 'should properly detect the end of the data list and start of the text' do
      doc = Nokogiri::HTML.fragment(subject.to_s)
      expect(doc.css("p:contains('For the most part')")).to be_present
    end
  end
end
