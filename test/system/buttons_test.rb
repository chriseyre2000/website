require "application_system_test_case"

class ButtonsTest < ApplicationSystemTestCase
  test "Ajax buttons should be disabled until call is successful" do
    @mentor = create(:user)
    @track = create(:track, title: "Ruby")
    create :track_mentorship, user: @mentor, track: @track

    @solution = create :solution, exercise: create(:exercise, track: @track)
    @iteration = create :iteration, solution: @solution

    sign_in!(@mentor)
    create :solution_mentorship, solution: @solution, user: @mentor
    visit mentor_solution_path(@solution)

    # Stub an internal method to make sure we're checking for disabled
    # before the ajax call has returned
    CreateNotification.expects(:call).yields { sleep 0.5 }

    find("#discussion_post_content").set "Great work!"
    click_on "Comment"

    assert_equal find(".comment-button")["disabled"], "true"
    assert_selector(".widget-discussion-post")
  end
end
