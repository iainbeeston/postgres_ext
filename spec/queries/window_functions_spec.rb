require 'spec_helper'

describe 'Window functions' do
  describe 'ranked' do
    it 'uses the order when no order is passed to ranked' do
      query = Person.order(lucky_number: :desc).ranked
      query.to_sql.should eq 'SELECT "people".*, rank() OVER (ORDER BY "people"."lucky_number" DESC) FROM "people"   ORDER BY "people"."lucky_number" DESC'
    end

    it 'uses the order when no order is passed to ranked, swapped calls' do
      query = Person.ranked.order(lucky_number: :desc)
      query.to_sql.should eq 'SELECT "people".*, rank() OVER (ORDER BY "people"."lucky_number" DESC) FROM "people"   ORDER BY "people"."lucky_number" DESC'
    end

    it 'uses the rank value when there is an order passed to it' do
      query = Person.ranked(lucky_number: :desc)
      query.to_sql.should eq 'SELECT "people".*, rank() OVER (ORDER BY "people"."lucky_number" DESC) FROM "people"'
    end

    it 'uses the rank value when a symbol passed to it' do
      query = Person.ranked(:lucky_number)
      query.to_sql.should eq 'SELECT "people".*, rank() OVER (ORDER BY "people"."lucky_number" ASC) FROM "people"'
    end

    it 'uses the rank value when a string passed to it' do
      query = Person.ranked('lucky_number desc')
      query.to_sql.should eq 'SELECT "people".*, rank() OVER (ORDER BY lucky_number desc) FROM "people"'
    end

    it 'combines the order and rank' do
      query = Person.ranked(lucky_number: :desc).order(id: :asc)
      query.to_sql.should eq 'SELECT "people".*, rank() OVER (ORDER BY "people"."lucky_number" DESC) FROM "people"   ORDER BY "people"."id" ASC'
    end

    it 'executes the query with the rank' do
      Person.create!
      Person.create!

      ranked_people = Person.ranked(:id)
      ranked_people[0].rank.should eq 1
      ranked_people[1].rank.should eq 2
    end
  end
end
