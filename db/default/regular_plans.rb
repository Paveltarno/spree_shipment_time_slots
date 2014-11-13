# Creates plans for each day of the week
for i in 0..6
  Spree::RegularPlan.create!(day: i)
end
