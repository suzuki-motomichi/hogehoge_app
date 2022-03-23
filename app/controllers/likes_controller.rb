class LikesController < ApplicationController
  def create
    # post = Post.find(params[:post_id])
    # Like.create(user_id: current_user, post_id: params[:post_id])
    like = current_user.likes.create!(post_id: params[:post_id])
    # like.save
    # like = current_user.likes.build(post_id: params[:post_id])
    # post = Post.find(params[:post_id])
    # current_user.like(post)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    # binding.irb
    # unlike = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
    # unlike.destroy
    unlike = current_user.likes.find(params[:id]).post
    current_user.like_posts.destroy(unlike)
    # current_user.unlike(post)
    redirect_back(fallback_location: root_path)
  end
end
