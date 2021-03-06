require File.expand_path '../spec_helper.rb', __FILE__

describe User do
  it { should have_property           :id }
  it { should have_property           :email }
  it { should have_property           :password }
end

describe Post do
  it { should have_property           :id }
  it { should have_property           :title }
  it { should have_property           :content }
  it { should have_property           :user_id }
end