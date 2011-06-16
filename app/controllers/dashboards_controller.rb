class DashboardsController < ApplicationController
  before_filter  :admin_or_user_required
  # GET /dashboards
  # GET /dashboards.json
  def index
    @dashboard =  current_user.dashboard unless current_user.dashboard.nil?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=> @dashboard }
    end
  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
    @dashboard = current_user.dashboard
    @db_tables=UserDatabase::ReadDb.new(@dashboard.db_name)
    @tables=@db_tables.get_tables

    @tab_hash=Hash.new
    @tables.each do |table|
       col=  @db_tables.get_columns(table.first)
       @arr=Hash.new
       col.each do |c|
         @arr[c[0]]=c[1]
       end
    @tab_hash[table.first]=@arr
    end
    pp @tab_hash

     respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=> @dashboard }
    end
  end

  # GET /dashboards/new
  # GET /dashboards/new.json
  def new
    @dashboard = current_user.build_dashboard if current_user.dashboard.nil?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=> @dashboard }
    end
  end

  # GET /dashboards/1/edit
  def edit
    @dashboard = current_user.dashboard
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    if current_user.dashboard.nil?
      @dashboard = Dashboard.new(params[:dashboard])
      @dashboard.user=current_user
      respond_to do |format|
        if @dashboard.save
          @db=UserDatabase::CreateDb.new(@dashboard.db_name)
          @db.create

          format.html { redirect_to @dashboard, :notice=> 'Database created.' }
          format.json { render :json=> @dashboard, :status=> :created, :location=> @dashboard }
        else
          format.html { render :action=> "new" }
          format.json { render :json=> @dashboard.errors, :status=> :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
          format.html { render :action=> "new" }
          format.json { render :json=> @dashboard.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # PUT /dashboards/1
  # PUT /dashboards/1.json
  def update
    @dashboard = current_user.dashboard

    respond_to do |format|
      if @dashboard.update_attributes(params[:dashboard])
        format.html { redirect_to @dashboard, :notice=> 'Dashboard was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action=> "edit" }
        format.json { render :json=> @dashboard.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboard.destroy

    respond_to do |format|
      format.html { redirect_to dashboards_url }
      format.json { head :ok }
    end
  end
end
