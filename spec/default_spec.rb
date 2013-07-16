require 'chefspec'

describe 'git-annex::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'git-annex::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
