surveyApp.factory 'FileUploadService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  destroyUploadFile: $resource "/destroy_upload_file.json", {}, query: { method: 'GET', isArray: false }

  getCampaigns: $resource "/get_upload_file_campaigns.json", {}, query: { method: 'GET', isArray: false }

  getUploadFiles: $resource "/get_upload_files.json", {}, query: { method: 'GET', isArray: false }

  updateUploadFile: $resource "/update_upload_file.json", {}, query: { method: 'GET', isArray: false }

]