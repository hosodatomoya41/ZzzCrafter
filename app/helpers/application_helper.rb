module ApplicationHelper
  def flash_classname(message_type)
    case message_type.to_sym
    when :success
      "bg-green-500 text-white"
    when :danger
      "bg-red-500 text-white"
    else
      "bg-gray-500 text-white"
    end
  end
end
