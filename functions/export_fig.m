function export_fig(formato, filename)

exportgraphics(gcf, [filename,'.','pdf'], 'ContentType', 'vector');