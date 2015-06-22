require 'rails_helper'

RSpec.feature 'Courses: Groups' do
  let(:instance) { create(:instance) }

  with_tenant(:instance) do
    let(:course) { create(:course) }
    let(:user) { create(:administrator) }
    let!(:groups) { create_list(:course_group, 3, course: course) }
    before { login_as(user, scope: :user) }

    scenario 'Course staff can view all the groups in course' do
      visit course_groups_path(course)

      expect(page).to have_link(nil, href: new_course_group_path(course))

      groups.each do |group|
        expect(page).to have_selector('td', text: group.name)
        expect(page).to have_link(nil, href: edit_course_group_path(course, group))
        expect(page).to have_link(nil, href: course_group_path(course, group))
      end
    end

    let!(:course_users) { create_list(:course_user, 3, course: course) }
    let(:sample_user) { course_users.sample.user }
    scenario 'Course staff can create a group' do
      visit new_course_group_path(course)

      click_button 'create'
      expect(page).to have_css('div.has-error')

      fill_in 'group_name', with: 'Group name'

      within '#group_user_ids' do
        find("option[value='#{sample_user.id}']").select_option
      end

      click_button 'create'
      expect(sample_user.course_groups.count).to eq(1)
    end

    let(:group) { create(:course_group, course: course) }
    scenario 'Course staff cannot set the group title to empty' do
      visit edit_course_group_path(course, group)

      fill_in 'group_name', with: ''
      click_button 'update'
      expect(page).to have_css('div.has-error')
    end
  end
end