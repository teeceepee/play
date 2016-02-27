require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = tags(:one)
  end

  test "should get index" do
    get tags_url
    assert_response :success
  end

  test "should get new" do
    get new_tag_url
    assert_response :success
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post tags_url, params: { tag: { dockerfile_dir: @tag.dockerfile_dir, git_commit: @tag.git_commit, git_url: @tag.git_url, name: @tag.name, repo_id: @tag.repo_id } }
    end

    assert_redirected_to tag_path(Tag.last)
  end

  test "should show tag" do
    get tag_url(@tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_tag_url(@tag)
    assert_response :success
  end

  test "should update tag" do
    patch tag_url(@tag), params: { tag: { dockerfile_dir: @tag.dockerfile_dir, git_commit: @tag.git_commit, git_url: @tag.git_url, name: @tag.name, repo_id: @tag.repo_id } }
    assert_redirected_to tag_path(@tag)
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete tag_url(@tag)
    end

    assert_redirected_to tags_path
  end
end
