# config/initializers/fix_active_storage_validations.rb
#
# Workaround for a bug in active_storage_validations v3.0.2's railtie,
# which incorrectly includes the ActiveStorageValidations module instead
# of ActiveStorageValidations::Attached::Validations into ActiveRecord::Base.
# This initializer ensures the correct module is included, making custom
# validators like :content_type recognized by models.

ActiveSupport.on_load(:active_record) do
    # Ensure the module exists before trying to include it
    if defined?(ActiveStorageValidations::Attached::Validations)
      include ActiveStorageValidations::Attached::Validations
    else
      # Log a warning or raise an error if the module is not found,
      # which would indicate a deeper problem or an unexpected gem version.
      Rails.logger.warn "ActiveStorageValidations::Attached::Validations module not found. " \
                        "The fix_active_storage_validations initializer might be unnecessary or incorrect for this gem version."
    end
  end
  