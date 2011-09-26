module TweetsHelper
  def maximum_content_length
    Tweet.validators_on(:content)[0].options[:maximum]
  end

  def cut_tweet(tweet)
    content = tweet.content
    splitted_content = content.split(" ")
    if content.length > 20
      @content = "#{content[0...20]} ..."
    else
      @content = "#{content}"
    end
    return @content
  end

end
