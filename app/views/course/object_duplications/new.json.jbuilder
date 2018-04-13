# frozen_string_literal: true
json.currentHost current_tenant.host

json.currentCourse do
  json.(current_course, :title, :start_at)
  json.duplicationModesAllowed ([].tap do |modes|
    modes << 'COURSE' if current_course.course_duplicable?
    modes << 'OBJECT' if current_course.objects_duplicable?
  end)
  json.enabledComponents map_components_to_frontend_tokens(current_component_host.enabled_components)
  json.unduplicableObjectTypes (current_course.disabled_cherrypickable_types.map do |klass|
    cherrypickable_items_hash[klass]
  end)
end

json.destinationCourses @destination_courses do |course|
  json.(course, :id, :title)
  json.path course_path(course)
  json.host course.instance.host
  json.rootFolder do
    root_folder = @root_folder_map[course.id]
    json.subfolders root_folder.children.map(&:name)
    json.materials root_folder.materials.map(&:name)
  end
  json.enabledComponents enabled_component_tokens(course)
end

json.assessmentsComponent @categories do |category|
  json.(category, :id, :title)
  json.tabs category.tabs do |tab|
    json.(tab, :id, :title)
    json.assessments tab.assessments do |assessment|
      json.(assessment, :id, :title, :published)
    end
  end
end

json.surveyComponent @surveys do |survey|
  json.(survey, :id, :title, :published)
end

json.achievementsComponent @achievements do |achievement|
  json.(achievement, :id, :title, :published)
  json.url achievement_badge_path(achievement)
end

json.materialsComponent @folders do |folder|
  json.(folder, :id, :name, :parent_id)
  json.materials folder.materials do |material|
    json.(material, :id, :name)
  end
end

json.videosComponent @video_tabs do |tab|
  json.(tab, :id, :title)
  json.videos tab.videos do |video|
    json.(video, :id, :title, :published)
  end
end
