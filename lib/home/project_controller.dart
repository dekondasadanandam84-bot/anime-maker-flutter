import 'package:flutter/foundation.dart';

import 'models/project_model.dart';
import 'models/project_settings_model.dart';
import 'models/anime_series_model.dart';
import 'models/anime_movie_model.dart';
import 'models/season_model.dart';
import 'models/episode_model.dart';
import 'models/clip_model.dart';

enum ProjectFlowType {
  animeSeries,
  animeMovie,
  mangaSeries,
  mangaBook,
  editCurrentProject,
}

class ProjectController extends ChangeNotifier {
  ProjectController({
    List<ProjectModel> initialProjects = const [],
  }) : _projects = List<ProjectModel>.from(initialProjects);

  // ============================================================
  // PROJECT STORAGE
  // ============================================================

  final List<ProjectModel> _projects;

  // ============================================================
  // CURRENT PROJECT CONTEXT
  // ============================================================

  String? _currentProjectId;
  String? _currentSeasonId;
  String? _currentEpisodeId;
  String? _currentClipId;

  // ============================================================
  // PROJECT FLOW
  // ============================================================

  ProjectFlowType? _projectFlowType;

  ProjectFlowType? get projectFlowType => _projectFlowType;

  bool get isCreatingProject =>
      _projectFlowType == ProjectFlowType.animeSeries ||
      _projectFlowType == ProjectFlowType.animeMovie ||
      _projectFlowType == ProjectFlowType.mangaSeries ||
      _projectFlowType == ProjectFlowType.mangaBook;

  bool get isEditingProject =>
      _projectFlowType == ProjectFlowType.editCurrentProject;

  // ============================================================
  // ALL PROJECTS
  // ============================================================

  List<ProjectModel> get projects => List.unmodifiable(_projects);

  int get projectCount => _projects.length;

  List<ProjectModel> get animeSeriesProjects {
    return List.unmodifiable(
      _projects.where(
        (project) => project.projectType == ProjectType.animeSeries,
      ),
    );
  }

  List<ProjectModel> get animeMovieProjects {
    return List.unmodifiable(
      _projects.where(
        (project) => project.projectType == ProjectType.animeMovie,
      ),
    );
  }

  // ============================================================
  // FIND PROJECT
  // ============================================================

  ProjectModel? findProject(String projectId) {
    for (final project in _projects) {
      if (project.id == projectId) {
        return project;
      }
    }

    return null;
  }

  // Compatibility method for existing screens.
  ProjectModel? getProjectById(String projectId) {
    return findProject(projectId);
  }

  // ============================================================
  // CURRENT PROJECT
  // ============================================================

  String? get currentProjectId => _currentProjectId;

  ProjectModel? get currentProject {
    final id = _currentProjectId;

    if (id == null) {
      return null;
    }

    return findProject(id);
  }

  String? get currentProjectName {
    return currentProject?.name;
  }

  ProjectType? get currentProjectType {
    return currentProject?.projectType;
  }

  ProjectSettingsModel? get currentSettings {
    return currentProject?.settings;
  }

  ProjectAspectRatio? get currentAspectRatio {
    return currentProject?.settings.aspectRatio;
  }

  String? get currentResolution {
    return currentProject?.settings.resolution;
  }

  double? get currentFps {
    return currentProject?.settings.fps;
  }

  String? get currentQuality {
    return currentProject?.settings.quality;
  }

  AnimeSeriesModel? get currentAnimeSeries {
    return currentProject?.animeSeries;
  }

  AnimeMovieModel? get currentAnimeMovie {
    return currentProject?.animeMovie;
  }

  bool get isCurrentAnimeSeries {
    return currentProjectType == ProjectType.animeSeries;
  }

  bool get isCurrentAnimeMovie {
    return currentProjectType == ProjectType.animeMovie;
  }

  // ============================================================
  // CURRENT SEASON
  // ============================================================

  String? get currentSeasonId => _currentSeasonId;

  SeasonModel? get currentSeason {
    final series = currentAnimeSeries;
    final id = _currentSeasonId;

    if (series == null || id == null) {
      return null;
    }

    for (final season in series.seasons) {
      if (season.id == id) {
        return season;
      }
    }

    return null;
  }

  List<SeasonModel> get currentSeasons {
    final series = currentAnimeSeries;

    if (series == null) {
      return const [];
    }

    return List.unmodifiable(series.seasons);
  }

  // ============================================================
  // CURRENT EPISODE
  // ============================================================

  String? get currentEpisodeId => _currentEpisodeId;

  EpisodeModel? get currentEpisode {
    final season = currentSeason;
    final id = _currentEpisodeId;

    if (season == null || id == null) {
      return null;
    }

    for (final episode in season.episodes) {
      if (episode.id == id) {
        return episode;
      }
    }

    return null;
  }

  List<EpisodeModel> get currentEpisodes {
    final season = currentSeason;

    if (season == null) {
      return const [];
    }

    return List.unmodifiable(season.episodes);
  }

  // ============================================================
  // CURRENT CLIP
  // ============================================================

  String? get currentClipId => _currentClipId;

  ClipModel? get currentClip {
    final id = _currentClipId;

    if (id == null) {
      return null;
    }

    final episode = currentEpisode;

    if (episode != null) {
      for (final clip in episode.clips) {
        if (clip.id == id) {
          return clip;
        }
      }
    }

    final movie = currentAnimeMovie;

    if (movie != null) {
      for (final clip in movie.clips) {
        if (clip.id == id) {
          return clip;
        }
      }
    }

    return null;
  }

  List<ClipModel> get currentClips {
    final episode = currentEpisode;

    if (episode != null) {
      return List.unmodifiable(episode.clips);
    }

    final movie = currentAnimeMovie;

    if (movie != null) {
      return List.unmodifiable(movie.clips);
    }

    return const [];
  }

  // ============================================================
  // PROJECT FLOW CONTROL
  // ============================================================

  void beginCreateProject(ProjectFlowType type) {
    _projectFlowType = type;

    _currentProjectId = null;
    _currentSeasonId = null;
    _currentEpisodeId = null;
    _currentClipId = null;

    notifyListeners();
  }

  void beginEditCurrentProject() {
    if (currentProject == null) {
      return;
    }

    _projectFlowType = ProjectFlowType.editCurrentProject;

    notifyListeners();
  }

  void clearProjectFlow() {
    _projectFlowType = null;

    notifyListeners();
  }

  // ============================================================
  // SELECT PROJECT
  // ============================================================

  bool selectProject(String projectId) {
    if (findProject(projectId) == null) {
      return false;
    }

    _currentProjectId = projectId;
    _currentSeasonId = null;
    _currentEpisodeId = null;
    _currentClipId = null;

    notifyListeners();

    return true;
  }

  // ============================================================
  // SELECT SEASON
  // ============================================================

  bool selectSeason(String seasonId) {
    final series = currentAnimeSeries;

    if (series == null) {
      return false;
    }

    final exists = series.seasons.any(
      (season) => season.id == seasonId,
    );

    if (!exists) {
      return false;
    }

    _currentSeasonId = seasonId;
    _currentEpisodeId = null;
    _currentClipId = null;

    notifyListeners();

    return true;
  }

  // ============================================================
  // SELECT EPISODE
  // ============================================================

  bool selectEpisode(String episodeId) {
    final season = currentSeason;

    if (season == null) {
      return false;
    }

    final exists = season.episodes.any(
      (episode) => episode.id == episodeId,
    );

    if (!exists) {
      return false;
    }

    _currentEpisodeId = episodeId;
    _currentClipId = null;

    notifyListeners();

    return true;
  }

  // ============================================================
  // SELECT CLIP
  // ============================================================

  bool selectClip(String clipId) {
    final episode = currentEpisode;

    if (episode != null) {
      final exists = episode.clips.any(
        (clip) => clip.id == clipId,
      );

      if (exists) {
        _currentClipId = clipId;

        notifyListeners();

        return true;
      }
    }

    final movie = currentAnimeMovie;

    if (movie != null) {
      final exists = movie.clips.any(
        (clip) => clip.id == clipId,
      );

      if (exists) {
        _currentClipId = clipId;

        notifyListeners();

        return true;
      }
    }

    return false;
  }

  // ============================================================
  // CLEAR CURRENT CONTEXT
  // ============================================================

  void clearCurrentContext() {
    _currentProjectId = null;
    _currentSeasonId = null;
    _currentEpisodeId = null;
    _currentClipId = null;

    notifyListeners();
  }

  // ============================================================
  // CREATE PROJECT
  // ============================================================

  ProjectModel createProject({
    required ProjectType projectType,
    required String name,
    required ProjectSettingsModel settings,
  }) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final projectId = 'project_$timestamp';

    late ProjectModel project;

    switch (projectType) {
      case ProjectType.animeSeries:
        final series = AnimeSeriesModel(
          id: 'series_$timestamp',
          name: name,
          seasons: const [],
        );

        project = ProjectModel(
          id: projectId,
          name: name,
          projectType: ProjectType.animeSeries,
          settings: settings,
          animeSeries: series,
        );

      case ProjectType.animeMovie:
        final movie = AnimeMovieModel(
          id: 'movie_$timestamp',
          name: name,
          clips: const [],
        );

        project = ProjectModel(
          id: projectId,
          name: name,
          projectType: ProjectType.animeMovie,
          settings: settings,
          animeMovie: movie,
        );
    }

    _projects.add(project);

    _currentProjectId = project.id;
    _currentSeasonId = null;
    _currentEpisodeId = null;
    _currentClipId = null;

    notifyListeners();

    return project;
  }

  // ============================================================
  // DELETE PROJECT
  // ============================================================

  bool deleteProject(String projectId) {
    final index = _projects.indexWhere(
      (project) => project.id == projectId,
    );

    if (index == -1) {
      return false;
    }

    _projects.removeAt(index);

    if (_currentProjectId == projectId) {
      _currentProjectId = null;
      _currentSeasonId = null;
      _currentEpisodeId = null;
      _currentClipId = null;
    }

    notifyListeners();

    return true;
  }

  // ============================================================
  // UPDATE CURRENT PROJECT
  // ============================================================

  bool updateCurrentProject({
  String? name,
  ProjectSettingsModel? settings,
}) {
  final project = currentProject;

  if (project == null) {
    return false;
  }

  final updatedName = name ?? project.name;

  AnimeSeriesModel? updatedSeries = project.animeSeries;
  AnimeMovieModel? updatedMovie = project.animeMovie;

  if (name != null && updatedSeries != null) {
    updatedSeries = updatedSeries.copyWith(
      name: updatedName,
    );
  }

  if (name != null && updatedMovie != null) {
    updatedMovie = updatedMovie.copyWith(
      name: updatedName,
    );
  }

  final updatedProject = project.copyWith(
    name: updatedName,
    settings: settings ?? project.settings,
    animeSeries: updatedSeries,
    animeMovie: updatedMovie,
  );

  return updateProject(updatedProject);
}

  // ============================================================
  // UPDATE PROJECT NAME
  // ============================================================

  bool updateCurrentProjectName(String name) {
    final cleanedName = name.trim();

    if (cleanedName.isEmpty) {
      return false;
    }

    return updateCurrentProject(
      name: cleanedName,
    );
  }

  // ============================================================
  // UPDATE PROJECT SETTINGS
  // ============================================================

  bool updateCurrentProjectSettings({
    ProjectAspectRatio? aspectRatio,
    String? resolution,
    double? fps,
    String? quality,
  }) {
    final settings = currentSettings;

    if (settings == null) {
      return false;
    }

    final updatedSettings = settings.copyWith(
      aspectRatio: aspectRatio ?? settings.aspectRatio,
      resolution: resolution ?? settings.resolution,
      fps: fps ?? settings.fps,
      quality: quality ?? settings.quality,
    );

    return updateCurrentProject(
      settings: updatedSettings,
    );
  }

  // ============================================================
  // UPDATE PROJECT
  // ============================================================

  bool updateProject(ProjectModel updatedProject) {
    final index = _projects.indexWhere(
      (project) => project.id == updatedProject.id,
    );

    if (index == -1) {
      return false;
    }

    _projects[index] = updatedProject;

    notifyListeners();

    return true;
  }

  // ============================================================
  // CREATE SEASON
  // ============================================================

  SeasonModel? createSeason({
    String? name,
  }) {
    final project = currentProject;
    final series = currentAnimeSeries;

    if (project == null || series == null) {
      return null;
    }

    final number = series.seasons.isEmpty
        ? 1
        : series.seasons
                .map((season) => season.number)
                .reduce(
                  (a, b) => a > b ? a : b,
                ) +
            1;

    final cleaned = _stripSeasonPrefix(
      name?.trim() ?? '',
    );

    final season = SeasonModel(
      id: 'season_${number}_${DateTime.now().microsecondsSinceEpoch}',
      number: number,
      name: cleaned.isEmpty
          ? 'Season $number'
          : cleaned,
      episodes: const [],
    );

    _replaceCurrentProject(
      project.copyWith(
        animeSeries: series.copyWith(
          seasons: [
            ...series.seasons,
            season,
          ],
        ),
      ),
    );

    _currentSeasonId = season.id;
    _currentEpisodeId = null;
    _currentClipId = null;

    notifyListeners();

    return season;
  }

  // ============================================================
  // RENAME SEASON
  // ============================================================

  bool renameSeason({
    required String seasonId,
    required String newName,
  }) {
    final project = currentProject;
    final series = currentAnimeSeries;

    if (project == null || series == null) {
      return false;
    }

    SeasonModel? existing;

    for (final season in series.seasons) {
      if (season.id == seasonId) {
        existing = season;
        break;
      }
    }

    if (existing == null) {
      return false;
    }

    final cleaned = _stripSeasonPrefix(
      newName.trim(),
    );

    final updatedSeason = existing.copyWith(
      name: cleaned.isEmpty
          ? 'Season ${existing.number}'
          : cleaned,
    );

    final updatedSeasons = series.seasons.map(
      (season) {
        if (season.id == seasonId) {
          return updatedSeason;
        }

        return season;
      },
    ).toList();

    _replaceCurrentProject(
      project.copyWith(
        animeSeries: series.copyWith(
          seasons: updatedSeasons,
        ),
      ),
    );

    notifyListeners();

    return true;
  }

  // ============================================================
  // DELETE SEASON
  // ============================================================

  bool deleteSeason(String seasonId) {
    final project = currentProject;
    final series = currentAnimeSeries;

    if (project == null || series == null) {
      return false;
    }

    final exists = series.seasons.any(
      (season) => season.id == seasonId,
    );

    if (!exists) {
      return false;
    }

    final updatedSeasons = series.seasons
        .where(
          (season) => season.id != seasonId,
        )
        .toList();

    _replaceCurrentProject(
      project.copyWith(
        animeSeries: series.copyWith(
          seasons: updatedSeasons,
        ),
      ),
    );

    if (_currentSeasonId == seasonId) {
      _currentSeasonId = null;
      _currentEpisodeId = null;
      _currentClipId = null;
    }

    notifyListeners();

    return true;
  }

  // ============================================================
  // CREATE EPISODE
  // ============================================================

  EpisodeModel? createEpisode({
    String? name,
  }) {
    final project = currentProject;
    final season = currentSeason;

    if (project == null || season == null) {
      return null;
    }

    final number = season.episodes.isEmpty
        ? 1
        : season.episodes
                .map(
                  (episode) => episode.episodeNumber,
                )
                .reduce(
                  (a, b) => a > b ? a : b,
                ) +
            1;

    final cleaned = name?.trim() ?? '';

    final episode = EpisodeModel(
      id:
          'episode_${number}_${DateTime.now().microsecondsSinceEpoch}',
      name: cleaned.isEmpty
          ? 'Episode $number'
          : cleaned,
      episodeNumber: number,
      clips: const [],
    );

    _replaceCurrentSeasonDirect(
      project: project,
      season: season.copyWith(
        episodes: [
          ...season.episodes,
          episode,
        ],
      ),
    );

    _currentEpisodeId = episode.id;
    _currentClipId = null;

    notifyListeners();

    return episode;
  }

  // ============================================================
  // RENAME EPISODE
  // ============================================================

  bool renameEpisode({
    required String episodeId,
    required String newName,
  }) {
    final project = currentProject;
    final season = currentSeason;

    if (project == null || season == null) {
      return false;
    }

    EpisodeModel? existing;

    for (final episode in season.episodes) {
      if (episode.id == episodeId) {
        existing = episode;
        break;
      }
    }

    if (existing == null) {
      return false;
    }

    final cleaned = newName.trim();

    final updatedEpisode = existing.copyWith(
      name: cleaned.isEmpty
          ? 'Episode ${existing.episodeNumber}'
          : cleaned,
    );

    final updatedEpisodes = season.episodes.map(
      (episode) {
        if (episode.id == episodeId) {
          return updatedEpisode;
        }

        return episode;
      },
    ).toList();

    _replaceCurrentSeasonDirect(
      project: project,
      season: season.copyWith(
        episodes: updatedEpisodes,
      ),
    );

    notifyListeners();

    return true;
  }

  // ============================================================
  // DELETE EPISODE
  // ============================================================

  bool deleteEpisode(String episodeId) {
    final project = currentProject;
    final season = currentSeason;

    if (project == null || season == null) {
      return false;
    }

    final exists = season.episodes.any(
      (episode) => episode.id == episodeId,
    );

    if (!exists) {
      return false;
    }

    final updatedEpisodes = season.episodes
        .where(
          (episode) => episode.id != episodeId,
        )
        .toList();

    _replaceCurrentSeasonDirect(
      project: project,
      season: season.copyWith(
        episodes: updatedEpisodes,
      ),
    );

    if (_currentEpisodeId == episodeId) {
      _currentEpisodeId = null;
      _currentClipId = null;
    }

    notifyListeners();

    return true;
  }

  // ============================================================
  // CREATE CURRENT CLIP
  // ============================================================

  ClipModel? createCurrentClip({
    String? name,
  }) {
    final project = currentProject;

    if (project == null) {
      return null;
    }

    final episode = currentEpisode;

    if (episode != null) {
      final number = _nextClipNumber(
        episode.clips,
      );

      final cleaned = name?.trim() ?? '';

      const durationSeconds = 60;

      final frameCount =
          durationSeconds *
          project.settings.fps.round();

      final clip = ClipModel(
        id:
            'clip_${number}_${DateTime.now().microsecondsSinceEpoch}',
        number: number,
        name: cleaned.isEmpty
            ? 'Clip $number'
            : cleaned,
        durationSeconds: durationSeconds,
        frameCount: frameCount,
      );

      _replaceCurrentEpisode(
        project: project,
        updatedEpisode: episode.copyWith(
          clips: [
            ...episode.clips,
            clip,
          ],
        ),
      );

      _currentClipId = clip.id;

      notifyListeners();

      return clip;
    }

    final movie = currentAnimeMovie;

    if (movie != null) {
      final number = _nextClipNumber(
        movie.clips,
      );

      final cleaned = name?.trim() ?? '';

      const durationSeconds = 60;

      final frameCount =
          durationSeconds *
          project.settings.fps.round();

      final clip = ClipModel(
        id:
            'movie_clip_${number}_${DateTime.now().microsecondsSinceEpoch}',
        number: number,
        name: cleaned.isEmpty
            ? 'Clip $number'
            : cleaned,
        durationSeconds: durationSeconds,
        frameCount: frameCount,
      );

      _replaceCurrentProject(
        project.copyWith(
          animeMovie: movie.copyWith(
            clips: [
              ...movie.clips,
              clip,
            ],
          ),
        ),
      );

      _currentClipId = clip.id;

      notifyListeners();

      return clip;
    }

    return null;
  }

  // ============================================================
  // FIND CURRENT CLIP
  // ============================================================

  ClipModel? findCurrentClipById(
    String clipId,
  ) {
    for (final clip in currentClips) {
      if (clip.id == clipId) {
        return clip;
      }
    }

    return null;
  }

  // ============================================================
  // RENAME CLIP
  // ============================================================

  bool renameClip({
    required String clipId,
    required String newName,
  }) {
    final clips = currentClips;

    ClipModel? existing;

    for (final clip in clips) {
      if (clip.id == clipId) {
        existing = clip;
        break;
      }
    }

    if (existing == null) {
      return false;
    }

    final cleaned = newName.trim();

    final updatedClip = existing.copyWith(
      name: cleaned.isEmpty
          ? 'Clip ${existing.number}'
          : cleaned,
    );

    final updatedClips = clips.map(
      (clip) {
        if (clip.id == clipId) {
          return updatedClip;
        }

        return clip;
      },
    ).toList();

    _replaceCurrentClips(updatedClips);

    notifyListeners();

    return true;
  }

  // ============================================================
  // DELETE CLIP
  // ============================================================

  bool deleteClip(String clipId) {
    final clips = currentClips;

    final exists = clips.any(
      (clip) => clip.id == clipId,
    );

    if (!exists) {
      return false;
    }

    final updatedClips = clips
        .where(
          (clip) => clip.id != clipId,
        )
        .toList();

    _replaceCurrentClips(updatedClips);

    if (_currentClipId == clipId) {
      _currentClipId = null;
    }

    notifyListeners();

    return true;
  }

  // ============================================================
  // REORDER CLIPS
  // ============================================================

  void reorderCurrentClips({
    required int oldIndex,
    required int newIndex,
  }) {
    final clips = currentClips;

    if (oldIndex < 0 ||
        oldIndex >= clips.length) {
      return;
    }

    if (newIndex < 0 ||
        newIndex > clips.length) {
      return;
    }

    if (oldIndex == newIndex ||
        oldIndex + 1 == newIndex) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final updatedClips =
        List<ClipModel>.from(clips);

    final clip =
        updatedClips.removeAt(oldIndex);

    updatedClips.insert(
      newIndex,
      clip,
    );

    final renumbered = <ClipModel>[];

    for (int i = 0;
        i < updatedClips.length;
        i++) {
      renumbered.add(
        updatedClips[i].copyWith(
          number: i + 1,
        ),
      );
    }

    _replaceCurrentClips(
      renumbered,
    );

    notifyListeners();
  }

  // ============================================================
  // UPDATE CLIP TIMING
  // ============================================================

  void updateClipTiming({
    required String clipId,
    required int durationSeconds,
  }) {
    final project = currentProject;

    if (project == null) {
      return;
    }

    final clip =
        findCurrentClipById(clipId);

    if (clip == null) {
      return;
    }

    final safeDuration =
        durationSeconds.clamp(1, 60);

    final updatedClip = clip.copyWith(
      durationSeconds: safeDuration,
      frameCount:
          safeDuration *
          project.settings.fps.round(),
    );

    final updatedClips =
        currentClips.map(
      (item) {
        if (item.id == clipId) {
          return updatedClip;
        }

        return item;
      },
    ).toList();

    _replaceCurrentClips(
      updatedClips,
    );

    notifyListeners();
  }

  // ============================================================
// UPDATE CLIP FRAME COUNT
// ============================================================

bool updateClipFrameCount({
  required String clipId,
  required int frameCount,
}) {
  final project = currentProject;

  if (project == null) {
    return false;
  }

  final clip =
      findCurrentClipById(clipId);

  if (clip == null) {
    return false;
  }

  final safeFrameCount =
      frameCount < 1 ? 1 : frameCount;

  final updatedClip = clip.copyWith(
    frameCount: safeFrameCount,
  );

  final updatedClips =
      currentClips.map(
    (item) {
      if (item.id == clipId) {
        return updatedClip;
      }

      return item;
    },
  ).toList();

  _replaceCurrentClips(updatedClips);

  notifyListeners();

  return true;
}

  // ============================================================
  // INTERNAL PROJECT REPLACEMENT
  // ============================================================

  void _replaceCurrentProject(
    ProjectModel project,
  ) {
    final index = _projects.indexWhere(
      (item) => item.id == project.id,
    );

    if (index == -1) {
      return;
    }

    _projects[index] = project;
  }

  // ============================================================
  // INTERNAL SEASON UPDATE
  // ============================================================

  void _replaceCurrentSeasonDirect({
    required ProjectModel project,
    required SeasonModel season,
  }) {
    final series = currentAnimeSeries;

    if (series == null) {
      return;
    }

    _replaceCurrentProject(
      project.copyWith(
        animeSeries: series.copyWith(
          seasons: series.seasons.map(
            (item) {
              if (item.id == season.id) {
                return season;
              }

              return item;
            },
          ).toList(),
        ),
      ),
    );
  }

  // ============================================================
  // INTERNAL EPISODE UPDATE
  // ============================================================

  void _replaceCurrentEpisode({
    required ProjectModel project,
    required EpisodeModel updatedEpisode,
  }) {
    final series = currentAnimeSeries;
    final season = currentSeason;

    if (series == null ||
        season == null) {
      return;
    }

    final updatedSeason =
        season.copyWith(
      episodes: season.episodes.map(
        (episode) {
          if (episode.id ==
              updatedEpisode.id) {
            return updatedEpisode;
          }

          return episode;
        },
      ).toList(),
    );

    _replaceCurrentProject(
      project.copyWith(
        animeSeries: series.copyWith(
          seasons: series.seasons.map(
            (item) {
              if (item.id == season.id) {
                return updatedSeason;
              }

              return item;
            },
          ).toList(),
        ),
      ),
    );
  }

  // ============================================================
  // INTERNAL CLIP UPDATE
  // ============================================================

  void _replaceCurrentClips(
    List<ClipModel> clips,
  ) {
    final project = currentProject;

    if (project == null) {
      return;
    }

    final episode = currentEpisode;

    if (episode != null) {
      _replaceCurrentEpisode(
        project: project,
        updatedEpisode: episode.copyWith(
          clips: clips,
        ),
      );

      return;
    }

    final movie = currentAnimeMovie;

    if (movie != null) {
      _replaceCurrentProject(
        project.copyWith(
          animeMovie: movie.copyWith(
            clips: clips,
          ),
        ),
      );
    }
  }

  // ============================================================
  // INTERNAL HELPERS
  // ============================================================

  int _nextClipNumber(
    List<ClipModel> clips,
  ) {
    if (clips.isEmpty) {
      return 1;
    }

    return clips
            .map((clip) => clip.number)
            .reduce(
              (a, b) => a > b ? a : b,
            ) +
        1;
  }

  String _stripSeasonPrefix(
    String value,
  ) {
    if (value.isEmpty) {
      return '';
    }

    return value
        .replaceFirst(
          RegExp(
            r'^season\s+\d+\s*:?\s*',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
  }
}