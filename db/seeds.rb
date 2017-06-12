# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Organization.delete_all
Location.delete_all
Volunteer.delete_all
Resident.delete_all
Survey.delete_all
Question.delete_all
AnswerSet.delete_all

10.times do
  User.create!(
    user_type: 'Volunteer',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'topsecret',
    password_confirmation: 'topsecret',
    phonenumber: "1234567890",
    birthdate: rand(Date.civil(1940, 1, 1)..Date.civil(1990, 12, 31))
  )
end

10.times do
  User.create!(
    user_type: 'Resident',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'topsecret',
    password_confirmation: 'topsecret',
    phonenumber: "1234567890",
    birthdate: rand(Date.civil(1940, 1, 1)..Date.civil(1990, 12, 31))
  )
end

10.times do
  User.create!(
    user_type: 'Organization',
    first_name: Faker::Company.name,
    email: Faker::Internet.email,
    password: 'topsecret',
    password_confirmation: 'topsecret',
    phonenumber: "1234567890"
  )
end

organization_counter = 21
10.times do
  Organization.create!(
    address: Faker::Address.street_address,
    phone_number: "1234567890",
    user_id: organization_counter,
    name: User.find(organization_counter).first_name
  )
  organization_counter += 1
end

organization_counter = 1
10.times do
  Location.create!(
    branch_name: Faker::Company.name ,
    address:  Faker::Address.street_address,
    phone_number: "1234567890",
    volunteer_coordinator_name: Faker::Name.name,
    volunteer_coordinator_phone: "1234567890",
    organization_id: organization_counter
  )
  organization_counter += 1
end

survey_counter = 1
20.times do
  org = Organization.find(rand(1..10))
  s = Survey.create!(
    name: "The humble beginnings of a great survey ##{survey_counter}",
    organization_id: org.id
    )
  s.locations << org.locations.sample
  survey_counter += 1
end

open_question_set = ["Why do you want to volunteer?", "Why do you want to volunteer at Schelegel Villages?", "Tell us more about yourself"]
open_response_set = ["I love volunteering.", "I want to help out in my community.", "I want to give back."]

survey_counter = 1
20.times do
  Question.create!(
    question: open_question_set.sample,
    survey_id: survey_counter,
    question_type: "Open Response Question",
    ranking: 20
  )
  survey_counter += 1
end

survey_counter = 1
20.times do
  Question.create!(
    question: "What languages do you speak?",
    survey_id: survey_counter,
    question_type: "Multiple Choice Question",
    ranking: rand(1..100)
  )
  survey_counter += 1
end

survey_counter = 1
20.times do
  Question.create!(
    question: "How old are you?",
    survey_id: survey_counter,
    question_type: "Drop-Down Question",
    ranking: rand(1..100)
  )
survey_counter += 1
end

volunteer_counter = 1
10.times do
  v = Volunteer.create!(
    user_id: volunteer_counter
  )
  location_counter = rand(1..5)
  2.times do
    v.locations << Location.find(location_counter)
    location_counter += rand(1..5)
  end
  volunteer_counter += 1
end

resident_counter = 11
10.times do
  Resident.create!(
    user_id: resident_counter,
    location_id: Location.find(rand(1..10)).id
  )
  resident_counter += 1
end

question_counter = 1
language_options = ["English", "French", "Spanish"]

question_counter = 21
20.times do
  option_counter = 0
  3.times do
    AnswerSet.create!(
      question_id: question_counter,
      answer: language_options[option_counter]
    )
    option_counter += 1
  end
  question_counter += 1
end

age_options = (1...100).to_a

20.times do
  option_counter = 0
  100.times do
    AnswerSet.create!(
      question_id: question_counter,
      answer: age_options[option_counter]
    )
    option_counter += 1
  end
  question_counter += 1
end

volunteers = Volunteer.all

volunteers.each do |v|
  locations = v.locations
  surveys = []
  locations.each do |l|
    l.surveys.each do |s|
      surveys.push(s)
    end
  end
  questions = []
  surveys.each do |s|
    s.questions.each do |q|
      questions.push(q)
    end
  end
  questions.each do |q|
    if q.question_type == "Open Response Question"
      Response.create!(
        question_id: q.id,
        volunteer_id: v.id,
        response: open_response_set.sample
      )
    elsif q.question_type == "Multiple Choice Question"
      Response.create!(
        question_id: q.id,
        volunteer_id: v.id,
        response: "#{q.answer_sets.to_a.shuffle!.pop.answer}, #{q.answer_sets.to_a.shuffle!.pop.answer}"
      )
    elsif q.question_type == "Drop-Down Question"
      Response.create!(
        question_id: q.id,
        volunteer_id: v.id,
        response: q.answer_sets.sample.answer
      )
    end
  end
end


residents = Resident.all

residents.each do |r|
  surveys = r.location.surveys
  questions = []
  surveys.each do |s|
    s.questions.each do |q|
      questions.push(q)
    end
  end
  questions.each do |q|
    if q.question_type == "Open Response Question"
      Response.create!(
        question_id: q.id,
        resident_id: r.id,
        response: "N/A"
      )
    elsif q.question_type == "Multiple Choice Question"
      Response.create!(
        question_id: q.id,
        resident_id: r.id,
        response: "#{q.answer_sets.to_a.shuffle!.pop.answer}, #{q.answer_sets.to_a.shuffle!.pop.answer}"
      )
    elsif q.question_type == "Drop-Down Question"
      Response.create!(
        question_id: q.id,
        resident_id: r.id,
        response: q.answer_sets.sample.answer
      )
    end
  end
end
