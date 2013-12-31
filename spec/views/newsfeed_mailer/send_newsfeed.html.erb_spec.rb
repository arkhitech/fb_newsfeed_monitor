require 'spec_helper'
require 'rake'

describe "newsfeed_mailer/send_newsfeed.html.erb" do
  include Devise::TestHelpers
  User.destroy_all
 

  before :all do
    @user = User.find_by_name('testuser')
    @user ||= begin
      user = User.new(email: "test@gmail.com",
        encrypted_password: "$2a$10$TIJrH0tmQ7VuDeBVBIYhJ......................",
        provider: "facebook", uid: "10000697585", name: "testuser",
        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ")
      user.save!
      user
    end
  end
  
  before  :each do
    User.stub(:find_for_facebook_oauth).and_return(@user)
    sign_in @user
  end
  
  before :all do
    @search_phrases = SearchPhrase.find_by_user_id(@user.id)
    @search_phrases ||= begin
      search_phrase= SearchPhrase.new(keyword: "testkeyword",user_id: @user.id) #never hard code
      search_phrase.save!
      search_phrase
    end
    
    #@feed=[{"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"58079349432_10152103334464433", "actor_id"=>58079349432, "permalink"=>"https://www.facebook.com/OpenSourceForU/posts/10152103334464433", "created_time"=>1387285219, "message"=>"Millions of computers today run Java. Owing to the recent bugs reported in the software, Oracle released emergency security updates for both Java 6 and Java 7 versions. Do you know nearly 50 per cent of all Java users are even now running Java 6, which Oracle has officially denounced last month? Well, there's no denying that Java is a popular technology, but its security issues are something that Java users must be aware of."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"106105346504_10152063361521505", "actor_id"=>106105346504, "permalink"=>"https://www.facebook.com/photo.php?fbid=10152061687211505&set=a.122477366504.93715.106105346504&type=1", "created_time"=>1387285202, "message"=>"Here's your New Hijri Calendar entry for the day!\r\n\r\nچو با من یار بودے نور بودی\r\nبریدے از من و نور تو نار است\r\n\r\nترجمہ:\r\nتُو جب میرا دوست تھا تو نور تھا۔مجھ سے الگ ہوا تو اب تیرا نور بھی نار بن گیا ہے۔ (تیرا وجود\r\nمفید ہونے کے بجائے مضر ہو گیا ہے)۔\r\n\r\nTu jab mera dost tha to noor tha . mujh sai alag hua to ab tera noor bhi naar ban gaya hai.\r\n( tera wajood mufeed hone k bajaey muzar ho gaya hai).\r\n\r\nfor Complete Nazam click here : http://www.iqbal.com.pk/poetical-works/kuliyat-e-iqbal-farsi/payam-e-mashriq/954-poetical-works/kuliyat-e-iqbal-farsi/payam-e-mashriq/payam-e-mashriq-afkar/1084-mahawara-e-ilm-o-ishq"}, {"post_id"=>"134865236527166_762250683788615", "actor_id"=>134865236527166, "permalink"=>"https://www.facebook.com/photo.php?fbid=762021237144893&set=a.176793745667648.47685.134865236527166&type=1", "created_time"=>1387285201, "message"=>"Conheça a 99Motos, mais uma player que foca em entregas sobre duas rodas\r\n\r\n\r\nhttp://startups.ig.com.br/2013/conheca-a-99motos-mais-uma-player-que-foca-em-entregas-sobre-duas-rodas"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"100000537858382_742597689101486", "actor_id"=>100000537858382, "permalink"=>"https://www.facebook.com/NISAR.AHMED.AWAN/posts/742597689101486", "created_time"=>1387285169, "message"=>"aaaaaaahahahahaha :D :P"}, {"post_id"=>"58079349432_10152103334464433", "actor_id"=>58079349432, "permalink"=>"https://www.facebook.com/OpenSourceForU/posts/10152103334464433", "created_time"=>1387285219, "message"=>"Millions of computers today run Java. Owing to the recent bugs reported in the software, Oracle released emergency security updates for both Java 6 and Java 7 versions. Do you know nearly 50 per cent of all Java users are even now running Java 6, which Oracle has officially denounced last month? Well, there's no denying that Java is a popular technology, but its security issues are something that Java users must be aware of."}, {"post_id"=>"106105346504_10152063361521505", "actor_id"=>106105346504, "permalink"=>"https://www.facebook.com/photo.php?fbid=10152061687211505&set=a.122477366504.93715.106105346504&type=1", "created_time"=>1387285202, "message"=>"Here's your New Hijri Calendar entry for the day!\r\n\r\nچو با من یار بودے نور بودی\r\nبریدے از من و نور تو نار است\r\n\r\nترجمہ:\r\nتُو جب میرا دوست تھا تو نور تھا۔مجھ سے الگ ہوا تو اب تیرا نور بھی نار بن گیا ہے۔ (تیرا وجود\r\nمفید ہونے کے بجائے مضر ہو گیا ہے)۔\r\n\r\nTu jab mera dost tha to noor tha . mujh sai alag hua to ab tera noor bhi naar ban gaya hai.\r\n( tera wajood mufeed hone k bajaey muzar ho gaya hai).\r\n\r\nfor Complete Nazam click here : http://www.iqbal.com.pk/poetical-works/kuliyat-e-iqbal-farsi/payam-e-mashriq/954-poetical-works/kuliyat-e-iqbal-farsi/payam-e-mashriq/payam-e-mashriq-afkar/1084-mahawara-e-ilm-o-ishq"}, {"post_id"=>"134865236527166_762250683788615", "actor_id"=>134865236527166, "permalink"=>"https://www.facebook.com/photo.php?fbid=762021237144893&set=a.176793745667648.47685.134865236527166&type=1", "created_time"=>1387285201, "message"=>"Conheça a 99Motos, mais uma player que foca em entregas sobre duas rodas\r\n\r\n\r\nhttp://startups.ig.com.br/2013/conheca-a-99motos-mais-uma-player-que-foca-em-entregas-sobre-duas-rodas"}]
 

#    Rake::Task['fb_newsfeed_reminder:survey:fetch_news'].invoke
  end
    

  
  #  it "should render to 'send_newsfeed'" do
  #    render
  #    expect(view).to render_template("send_newsfeed")
  #  end
  
  #  it "should have title 'NewsFeed'" do
  #    render
  #    rendered.should have_title("Newsfeed")
  #  end
  #  
  #  
  #  it "should have link 'Sign Out'" do
  #    #    render & rendered are important
  #    render
  #    rendered.should have_link('Sign Out',href: destroy_user_session_path)
  #  end
  #  
  #    
  it "should have content'Powered By'" do
    #    render & rendered are important
    feed=[{"post_id"=>"631207816_10151857254557817", "actor_id"=>631207816, "permalink"=>"https://www.facebook.com/kamran.mustafa.mughal/posts/10151857254557817", "created_time"=>1387285273, "message"=>"Lack of sleep causes people to over eat which often leads to obesity."}, {"post_id"=>"58079349432_10152103334464433", "actor_id"=>58079349432, "permalink"=>"https://www.facebook.com/OpenSourceForU/posts/10152103334464433", "created_time"=>1387285219, "message"=>"Millions of computers today run Java. Owing to the recent bugs reported in the software, Oracle released emergency security updates for both Java 6 and Java 7 versions. Do you know nearly 50 per cent of all Java users are even now running Java 6, which Oracle has officially denounced last month? Well, there's no denying that Java is a popular technology, but its security issues are something that Java users must be aware of."}]
    NewsfeedMailer.any_instance.stub(:send_newsfeed).with(@user, feed).and_return(@feeds)
    render
    rendered.should have_content( "Facebook Newsfeed Monitor")
  end  

    
end