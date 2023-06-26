class IndexRedis
	def self.create_connection      
		redis = Redis.new(host: 'redis', port: 6379)
		return redis
	end

	def self.remove_comment_array_counter(article_id, user_id, rating)
		temp = rating == 1 ? "negative" : "postive"
		counter_name = "Article#{article_id.to_s}_#{temp}_comment_array_counter"
		redis =  IndexRedis.create_connection
		redis.spop(counter_name, user_id.to_i)
	end
	
	def self.insert_comment_array_counter(article_id, user_id, rating)
		temp = rating == 1 ? "positive" : "negative"
		counter_name = "Article#{article_id.to_s}_#{temp}_comment_array_counter"
		redis =  IndexRedis.create_connection
		redis.sadd(counter_name, user_id.to_i)
	end
	
	def self.get_comment_array_counter(article_id, user_id, rating)
		temp = rating == 1 ? "positive" : "negative"
		counter_name = "Article#{article_id.to_s}_#{temp}_comment_array_counter"
		redis =  IndexRedis.create_connection
		row_present_or_not = redis.sismember(counter_name,user_id.to_i)
		return row_present_or_not
	end
end
