# ===============================
# user
# ===============================
%w(super_admin manager_one manager_two manager_three).each do |user_name|
  user = User.new(name: user_name, email: "#{user_name}@example.com", password: 'password')
  user_name == 'super_admin' ? user.super_admin = true : user.manager = true
  user.save
end