class DevicesController < ApplicationController
  before_filter :find_school

  # GET /devices
  # GET /devices.xml
  def index
    @devices = Device.find(:all, :attribute => "puavoSchool", :value => @school.dn)
    # @devices = Device.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @devices }
    end
  end

  # GET /devices/1
  # GET /devices/1.xml
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @device }
      format.json  { render :json => @device }
    end
  end

  # GET /devices/new
  # GET /devices/new.xml
  # GET /devices/new.json
  def new
    @device = Device.new

    @device.objectClass_by_device_type = params[:device_type]

    respond_to do |format|
      unless params[:device_type]
        format.html {  render :partial => 'device_role' }
      else
        format.html # new.html.erb
        format.xml  { render :xml => @device }
        format.json
      end
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
  end

  # POST /devices
  # POST /devices.xml
  # POST /devices.json
  def create
    device_objectClass = params[:device][:classes]
    params[:device].delete(:classes)
    @device = Device.new( { :objectClass => device_objectClass }.merge( params[:device] ))

    @device.puavoSchool = @school.dn

    respond_to do |format|
      if @device.save
        format.html { redirect_to(device_path(@school, @device), :notice => 'Device was successfully created.') }
        format.xml  { render :xml => @device, :status => :created, :location => device_path(@school, @device) }
        format.json  { render :json => @device.to_json(:methods => [:host_certificate_request, :userCertificate]), :status => :created, :location => device_path(@school, @device) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
        format.json  { render :json => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.xml
  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to(device_path(@school, @device), :notice => 'Device was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.xml
  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    respond_to do |format|
      format.html { redirect_to(devices_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_school
    @school = School.find(params[:school_id])
  end
end
