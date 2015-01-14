class NotesController < ApplicationController
  def create
    user = current_user
    @note = user.notes.new(note_params)

    if @note.save
      inform("Note created")
      dest = track_url(@note.track)
    else
      flash[:errors] = @note.errors.full_messages
      track = Track.find(note_params[:track_id])
      if track
        dest = track_url(track)
      else
        flash[:errors] = "The track was deleted"
        dest = root_url
      end
    end

    redirect_to dest
  end

  def destroy
    note = Note.find(params[:note_id])
    dest = track_url(note.track)
    if note.user_id != current_user.id
      render text: "Oi. You can't delete someone else's note"
    else
      note.destroy
      redirect_to dest
    end
  end

  private

  def note_params
    params.require(:note).permit(:body, :track_id)
  end
end
