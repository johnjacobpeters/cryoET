function this = tom_HT_imageseries(projectstruct,seriesid)

this.projectstruct = projectstruct;
this.filenames = {};
this.fullfilenames = {};
this.currentfile = [];
this.goodbad = [];
this.micrographids = [];
this.resultname = '';
this.resultid = 0;
this.description = '';

setdbprefs('DataReturnFormat','numeric');
this.experimenttypeid = fetch(projectstruct.conn,'SELECT experiment_type_id FROM experiment_types WHERE name = ''imageseriessorting''');
setdbprefs('DataReturnFormat','structure');
this.micrographgroupid = 0;

this = class(this,'tom_HT_imageseries');

if ischar(seriesid)
    seriesid = getimageseriesid_from_name(this,seriesid);
end

this = get_micrographs_from_imageseries(this,seriesid);
this.micrographgroupid = seriesid;