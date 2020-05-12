require "test_helper"

class ChefTest < ActiveSupport::TestCase
  
  def setup
  	@chef = Chef.new(chefname: "mashrur", email: "mashrur@example.com")
  end

  test "chef should be valid" do 
  	assert @chef.valid?
  end

  test "chefname should be valid" do 
  	@chef.chefname = " "
  	assert_not @chef.valid?
  end

  test "chefname should be less than 30 characters" do 
  	@chef.chefname = "a" * 31
  	assert_not @chef.valid?
  end

  test "email should be present" do 
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email shouldn't be more than 255 characters" do 
  	@chef.email = "a" * 245 + "@example.com"
  	assert_not @chef.valid? 
  end

  test "email should accept correct format" do 
  	valid_emails = %w[user@example.com MASHRUR@gmail.com M.first@yahoo.ca 
  	                  john+smith@co.uk.org]
  	valid_emails.each do |valids|
  		@chef.email = valids
  		assert @chef.valid?, "#{valids.inspect} should be valid"
  	end
  end

  test "email should reject invalid addresses" do 
  	invalid_emails = %w[mashrur@example mashrur@example,com mashrur@gmail. 
  	                    joe@bar+foo.com]
  	invalid_emails.each do |invalids|
  		@chef.email = invalids
  		assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
  	end                    
  end

  test "email should be unique and case insensitive" do 
    duplicate_chef = @chef.dup 
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lower case before hitting DB" do 
    mixed_email = "JohN@Example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email  
  end

end