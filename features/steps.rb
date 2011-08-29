Given /^I have no aliases$/ do
  Alis.store.remove_all
  Alis.store.save!
end


Given /^I have the next aliases$/ do |table|
  table.hashes.each do |h|
    When "I run `alis set --alias '#{h[:alias]}' --execute '#{h[:execute]}' --tail '#{h[:tail]}'`"
  end
end

Then /^there should not be command "([^"]*)" in alis binary directory$/ do |cmd|
  File.exists?(File.join(Alis.bin_dir, cmd)).should == false
end

Then /^there should be command "([^"]*)" in alis binary directory$/ do |cmd|
  File.exists?(File.join(Alis.bin_dir, cmd)).should == true
end


# for debug
When /^shell exe "([^"]*)"$/ do |cmd|
  puts "================= SHELL EXECUTE ================="
  puts `#{cmd}`
  puts "=============== SHELL EXECUTE END ==============="
end
