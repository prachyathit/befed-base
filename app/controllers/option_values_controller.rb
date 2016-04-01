class OptionValuesController < ApplicationController

  def create
    @option = Option.find(params[:option_id])
    @option_values = @option.option_values.build(option_value_params)
    if @option.save
      flash[:success] = "Option value was successfully created"
      redirect_to @option
    else
      render @option
    end
  end

  def destroy
    @option = Option.find(params[:option_id])
    @option_value = @option.option_values.find_by(id: params[:id])
    @option_value.destroy
    flash[:success] = "Option vaue deleted"
    redirect_to @option
  end

  private

    def option_value_params
      params.require(:option_value).permit(:name, :position, :price)
    end
end
