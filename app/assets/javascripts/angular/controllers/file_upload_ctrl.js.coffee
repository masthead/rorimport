surveyApp.controller 'FileUploadCtrl', ['$scope', '$http', 'FileUploadService', '$location', '$pusher', ($scope, $http, FileUploadService, $location, $pusher) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getUploadFiles()

################################################################
############## Other Initializers ##############################


################################################################
############## Requst Control ##################################

  $scope.requestControl = {

    campaigns: []

    current_page: 1

    pagination: null

    params: {

      campaign_id: null

    }

    scopedUploadFile: null

    uploadFiles: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getUploadFiles()

    checkNeedScroll: ->
      if this.scopedUploadFile && this.scopedUploadFile.error != null && this.scopedUploadFile.error == true then return 'body-scrollable' else return null

    destroyUploadFile: (uploadFileId) ->
      if uploadFileId && parseInt(uploadFileId, 10) > 0
        FileUploadService.destroyUploadFile.query({ upload_file_id: uploadFileId }, (responseData) ->
          if responseData.errors == false
            $scope.getUploadFiles()
        )

    getUploadFiles: ->
      if this.current_page && this.current_page > 0
        FileUploadService.getUploadFiles.query({ page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.uploadFiles = responseData.upload_files
            $scope.requestControl.pagination = responseData.pagination
        )

    resetModal: ->
      this.scopedUploadFile = null
      this.campaigns = []

    setUpModal: (uploadFile, getCampaigns, uploadFileIndex) ->
      if uploadFile && uploadFileIndex >= 0
        this.scopedUploadFile = uploadFile
        this.scopedUploadFile.current_index = uploadFileIndex

        if getCampaigns == true
          FileUploadService.getCampaigns.query({ upload_file_id: this.scopedUploadFile.upload_file_id }, (responseData) ->
            if responseData.errors == false
              $scope.requestControl.campaigns = responseData.campaigns
          )

    updateUploadFile: ->
      if this.scopedUploadFile.upload_file_id && parseInt(this.scopedUploadFile.upload_file_id, 10) > 0
        FileUploadService.updateUploadFile.query({ upload_file_id: this.scopedUploadFile.upload_file_id, upload_file_params: this.params }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.uploadFiles[$scope.requestControl.scopedUploadFile.current_index] = responseData.upload_file

            $scope.requestControl.resetModal()
        )

  }

################################################################
################# Initialize ###################################

  init()

]
